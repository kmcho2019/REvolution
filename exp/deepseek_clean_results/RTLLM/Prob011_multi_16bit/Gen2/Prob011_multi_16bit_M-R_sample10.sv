module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State encoding
    localparam IDLE   = 2'b00;
    localparam WORKING = 2'b01;
    localparam DONE   = 2'b10;

    reg [1:0] state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    wire zero_multiplier = (bin == 16'd0);

    // Pre-calculated shift amounts (0-15)
    wire [31:0] shifted [0:15];
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : shift_gen
            assign shifted[i] = {16'd0, bin} << i;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        acc <= 32'd0;
                        count <= 4'd0;
                        state <= zero_multiplier ? DONE : WORKING;
                    end
                end
                
                WORKING: begin
                    if (areg[count]) begin
                        acc <= acc + shifted[count];
                    end
                    
                    if (count == 4'd15) begin
                        state <= DONE;
                    end else begin
                        count <= count + 1;
                    end
                end
                
                DONE: begin
                    yout <= acc;
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
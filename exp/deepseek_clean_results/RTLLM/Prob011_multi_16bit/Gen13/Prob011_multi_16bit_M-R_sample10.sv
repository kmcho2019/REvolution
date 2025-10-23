module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State machine definitions
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;
    
    reg [1:0] state;
    reg [3:0] i;            // 4-bit counter (0-15)
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] yout_r;
    wire [31:0] shifted_b [0:15]; // Pre-computed shifted versions
    
    // Generate all possible shifted versions
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : shift_gen
            assign shifted_b[j] = breg << j;
        end
    endgenerate

    // State machine and main logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= CALC;
                        areg <= ain;
                        breg <= bin;
                        yout_r <= 32'd0;
                        i <= 4'd0;
                    end
                end
                
                CALC: begin
                    if (areg[i]) begin
                        yout_r <= yout_r + shifted_b[i];
                    end
                    
                    if (i == 4'd15) begin
                        state <= DONE;
                    end
                    else begin
                        i <= i + 4'd1;
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    always @(*) begin
        yout = yout_r;
        done = (state == DONE);
    end

endmodule
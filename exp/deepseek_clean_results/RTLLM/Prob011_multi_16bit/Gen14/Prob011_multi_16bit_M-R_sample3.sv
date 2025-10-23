module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam RUN  = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [31:0] acc;
    reg [15:0] breg;

    // Combinational outputs
    assign yout = acc;
    assign done = (state == DONE);

    // Shift amount calculation
    wire [31:0] shifted_bin = bin << count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'b0;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= RUN;
                        areg <= ain;
                        breg <= bin;
                        acc <= 32'b0;
                        count <= 4'b0;
                    end
                end
                
                RUN: begin
                    if (areg[count]) begin
                        acc <= acc + shifted_bin;
                    end
                    
                    if (count == 4'b1111) begin
                        state <= DONE;
                    end
                    
                    count <= count + 1;
                end
                
                DONE: begin
                    if (!start) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
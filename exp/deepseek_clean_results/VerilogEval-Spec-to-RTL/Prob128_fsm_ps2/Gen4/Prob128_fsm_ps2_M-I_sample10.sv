module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // Registered input to break timing paths
    reg in3_reg;
    always @(posedge clk) in3_reg <= in[3];

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam BYTE1 = 4'b0010;
    localparam BYTE2 = 4'b0100;
    localparam BYTE3 = 4'b1000;
    
    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in3_reg) state <= BYTE1;
                end
                BYTE1: begin
                    done <= 1'b0;
                    state <= BYTE2;
                end
                BYTE2: begin
                    done <= 1'b0;
                    state <= BYTE3;
                end
                BYTE3: begin
                    done <= 1'b1;
                    if (in3_reg) state <= BYTE1;
                    else state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
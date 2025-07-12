module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 2-bit state register
reg [1:0] nextState; // 2-bit next state register

// Define states
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (in[3]) begin
                nextState = BYTE1;
            end else begin
                nextState = IDLE;
            end
        end
        BYTE1: begin
            nextState = BYTE2;
        end
        BYTE2: begin
            nextState = BYTE3;
        end
        BYTE3: begin
            nextState = IDLE;
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

assign done = (state == BYTE3);

endmodule
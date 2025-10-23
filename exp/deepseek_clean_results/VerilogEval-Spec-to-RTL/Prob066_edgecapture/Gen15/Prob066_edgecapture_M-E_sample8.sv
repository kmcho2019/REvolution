module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam ARMED = 2'b01;
    localparam TRIGGERED = 2'b10;

    reg [1:0] state [31:0];  // State for each bit

    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                state[i] <= IDLE;
                out[i] <= 1'b0;
            end
        end
        else begin
            for (i = 0; i < 32; i = i + 1) begin
                case (state[i])
                    IDLE: begin
                        if (in[i]) state[i] <= ARMED;
                        out[i] <= 1'b0;
                    end
                    ARMED: begin
                        if (!in[i]) state[i] <= TRIGGERED;
                        else state[i] <= ARMED;
                        out[i] <= 1'b0;
                    end
                    TRIGGERED: begin
                        out[i] <= 1'b1;  // Stay triggered until reset
                    end
                    default: state[i] <= IDLE;
                endcase
            end
        end
    end

endmodule
module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define states directly as 3-bit vectors for simplicity
reg [2:0] state;
localparam IDLE = 3'b000;
localparam DETECTED_1 = 3'b001;
localparam DETECTED_11 = 3'b010;
localparam DETECTED_110 = 3'b011;
localparam DETECTED_1101 = 3'b100;

// State machine logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) state <= DETECTED_1;
            end
            DETECTED_1: begin
                if (data) state <= DETECTED_11;
                else state <= IDLE;
            end
            DETECTED_11: begin
                if (!data) state <= DETECTED_110;
                else state <= DETECTED_1;
            end
            DETECTED_110: begin
                if (data) state <= DETECTED_1101;
                else state <= IDLE;
            end
            DETECTED_1101: begin
                if (reset) state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    if (reset) start_shifting <= 0;
    else if (state == DETECTED_1101 && !reset) start_shifting <= 1;
end

endmodule
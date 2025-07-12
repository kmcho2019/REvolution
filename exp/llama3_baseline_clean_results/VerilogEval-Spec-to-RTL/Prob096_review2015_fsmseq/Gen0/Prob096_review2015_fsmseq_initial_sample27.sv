module TopModule(
    input       clk,
    input       reset,
    input       data,
    output reg  start_shifting
);

// Define the states of the FSM
localparam   IDLE      = 4'b0000;
localparam   FOUND_1   = 4'b0001;
localparam   FOUND_11  = 4'b0011;
localparam   FOUND_110 = 4'b0110;
localparam   FOUND_1101 = 4'b1101;

reg [3:0] current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data) begin
                    current_state <= FOUND_1;
                end else begin
                    current_state <= IDLE;
                end
            end
            FOUND_1: begin
                if (data) begin
                    current_state <= FOUND_11;
                end else begin
                    current_state <= FOUND_1;
                end
            end
            FOUND_11: begin
                if (~data) begin
                    current_state <= FOUND_110;
                end else begin
                    current_state <= FOUND_1;
                end
            end
            FOUND_110: begin
                if (data) begin
                    current_state <= FOUND_1101;
                end else begin
                    current_state <= IDLE;
                end
            end
            FOUND_1101: begin
                start_shifting <= 1;
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

endmodule
module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // Use 2 bits to represent 4 states: Idle (0), S1 (1), S2 (2), S3 (3), S4 (4 or any other state value)

// State encoding
localparam IDLE = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;
localparam FOUND = 2'b12; // Using 2 bits to represent more than 4 states, but this will not affect functionality

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= S1;
                end
            end
            S1: begin
                if (data) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (~data) begin
                    state <= S3;
                end else begin
                    state <= S1;
                end
            end
            S3: begin
                if (data) begin
                    state <= FOUND;
                end else begin
                    state <= IDLE;
                end
            end
            default: begin // FOUND state
                start_shifting <= 1;
            end
        endcase
        if (state == FOUND) begin
            start_shifting <= 1;
        end
    end
end

endmodule
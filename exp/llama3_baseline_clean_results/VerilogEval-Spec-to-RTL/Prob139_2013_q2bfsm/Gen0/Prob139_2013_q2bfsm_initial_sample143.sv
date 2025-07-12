module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the states
localparam STATE_A = 3'b000; // Reset state
localparam STATE_B = 3'b001; // Set f to 1
localparam STATE_C = 3'b010; // Monitor x sequence
localparam STATE_D = 3'b011; // Set g to 1 and monitor y
localparam STATE_E = 3'b100; // g remains 1
localparam STATE_F = 3'b101; // g remains 0

reg [2:0] state;
reg [1:0] x_sequence; // 2-bit counter to track x sequence
reg [1:0] y_counter; // 2-bit counter to track clock cycles since g was set

always @(posedge clk) begin
    if (~resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_counter <= 0;
    end else begin
        case (state)
            STATE_A: begin
                state <= STATE_B;
                f <= 1;
                g <= 0;
            end
            STATE_B: begin
                state <= STATE_C;
                f <= 0;
                x_sequence <= 0;
            end
            STATE_C: begin
                if (x) begin
                    x_sequence <= {x_sequence[0], 1};
                end else if (x_sequence[1]) begin
                    x_sequence <= {x_sequence[0], 0};
                end else begin
                    x_sequence <= 0;
                end
                if (x_sequence == 2'b101) begin
                    state <= STATE_D;
                    g <= 1;
                    y_counter <= 0;
                end
            end
            STATE_D: begin
                y_counter <= y_counter + 1;
                if (y) begin
                    state <= STATE_E;
                end else if (y_counter == 2) begin
                    state <= STATE_F;
                    g <= 0;
                end
            end
            STATE_E: begin
                // Stay in this state
            end
            STATE_F: begin
                // Stay in this state
            end
            default: begin
                state <= STATE_A;
            end
        endcase
    end
end

endmodule
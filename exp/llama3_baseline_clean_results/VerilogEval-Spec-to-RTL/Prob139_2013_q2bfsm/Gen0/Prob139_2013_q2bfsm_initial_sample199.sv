module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;

// Define states
localparam STATE_A = 3'b000;
localparam STATE_B = 3'b001;
localparam STATE_C = 3'b010;
localparam STATE_D = 3'b011;
localparam STATE_E = 3'b100;
localparam STATE_F = 3'b101;

// Define x input sequence counter
reg [1:0] x_sequence;

// Define y input timer
reg [1:0] y_timer;

always @(posedge clk) begin
    if (~resetn) begin
        // Reset FSM to state A
        state <= STATE_A;
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_timer <= 0;
    end else begin
        case (state)
            STATE_A: begin
                // Stay in state A when reset is asserted
                if (resetn) begin
                    // Move to state B when reset is de-asserted
                    state <= STATE_B;
                end
            end
            STATE_B: begin
                // Set output f to 1 for one clock cycle
                f <= 1;
                state <= STATE_C;
            end
            STATE_C: begin
                // Monitor x input for sequence 1, 0, 1
                f <= 0; // Reset f after one clock cycle
                case (x_sequence)
                    2'b00: begin
                        if (x) begin
                            x_sequence <= 2'b01;
                        end
                    end
                    2'b01: begin
                        if (~x) begin
                            x_sequence <= 2'b10;
                        end else begin
                            x_sequence <= 2'b01;
                        end
                    end
                    2'b10: begin
                        if (x) begin
                            state <= STATE_D;
                            x_sequence <= 0;
                        end else begin
                            x_sequence <= 2'b10;
                        end
                    end
                endcase
            end
            STATE_D: begin
                // Set output g to 1 and monitor y input
                g <= 1;
                y_timer <= 0;
                state <= STATE_D;
                if (y) begin
                    state <= STATE_E;
                end else begin
                    y_timer <= y_timer + 1;
                    if (y_timer == 2) begin
                        state <= STATE_F;
                    end
                end
            end
            STATE_E: begin
                // Maintain output g = 1 permanently
                g <= 1;
            end
            STATE_F: begin
                // Set output g = 0 permanently
                g <= 0;
            end
        endcase
    end
end

endmodule
module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0, // reset state, outputs f=0, g=0
        B = 3'd1, // pulse f=1 for one cycle after reset release
        C = 3'd2, // monitor x pattern
        D = 3'd3, // pulse g=1 for one cycle after pattern detected
        E = 3'd4, // hold g=1, monitor y for up to 2 cycles
        F = 3'd5, // g=1 permanent
        G = 3'd6  // g=0 permanent
    } state_t;

    state_t state, next_state; // next_state used only internally for clarity

    reg [2:0] x_shift;    // shift register to hold last 3 samples of x
    reg [1:0] y_count;    // counter for up to 2 cycles monitoring y

    reg x_reg, y_reg;     // registered inputs

    always @(posedge clk) begin
        if (!resetn) begin
            // synchronous reset active low
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'b00;
            f       <= 1'b0;
            g       <= 1'b0;
            x_reg   <= 1'b0;
            y_reg   <= 1'b0;
        end else begin
            // register inputs
            x_reg <= x;
            y_reg <= y;

            // shift in the new x sample every clock except in reset state
            // For a cleaner approach, always shift x_reg except in state A or B (f pulse)
            // Actually, problem requires to detect '101' only after f pulse, so shifting from state C onwards.
            // To avoid off-by-one, shift every cycle except during reset and f pulse (states A and B)
            if (state == C || state == D || state == E || state == F || state == G) begin
                x_shift <= {x_shift[1:0], x_reg};
            end else begin
                x_shift <= 3'b000; // reset shift register during reset or f pulse states
            end

            // default output values
            f <= 1'b0;
            g <= 1'b0;

            case(state)
                A: begin
                    // Wait in reset state until resetn released
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'b00;
                    // stay in A until resetn=1
                    if (resetn)
                        state <= B;
                    else
                        state <= A;
                end

                B: begin
                    // pulse f=1 for one clock cycle
                    f <= 1'b1;
                    g <= 1'b0;
                    y_count <= 2'b00;
                    state <= C;
                end

                C: begin
                    // monitor x_shift pattern for '101'
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'b00;

                    if (x_shift == 3'b101)
                        state <= D;
                    else
                        state <= C;
                end

                D: begin
                    // pulse g=1 one clock cycle after pattern detected
                    f <= 1'b0;
                    g <= 1'b1;
                    y_count <= 2'b00;
                    state <= E;
                end

                E: begin
                    // hold g=1, monitor y input for up to 2 cycles
                    f <= 1'b0;
                    g <= 1'b1;

                    if (y_reg == 1'b1) begin
                        // y=1 detected, hold g=1 permanently
                        y_count <= 2'b00;
                        state <= F;
                    end else begin
                        // increment counter and check if reached 2 cycles
                        if (y_count == 2'd2) begin
                            // y=1 not detected within 2 cycles, g=0 permanent
                            y_count <= 2'b00;
                            state <= G;
                        end else begin
                            y_count <= y_count + 1'b1;
                            state <= E;
                        end
                    end
                end

                F: begin
                    // g=1 permanent
                    f <= 1'b0;
                    g <= 1'b1;
                    y_count <= 2'b00;
                    state <= F;
                end

                G: begin
                    // g=0 permanent
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'b00;
                    state <= G;
                end

                default: begin
                    // safety fallback
                    f <= 1'b0;
                    g <= 1'b0;
                    y_count <= 2'b00;
                    state <= A;
                end
            endcase
        end
    end

endmodule
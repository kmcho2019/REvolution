module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding: 0 = COPY (waiting for first '1'), 1 = INVERT (after first '1')
    reg state, next_state;
    reg inversion_bit, next_inversion_bit;
    reg x_reg;

    // Register input x to stabilize input and avoid glitches
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // State and inversion_bit registers with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;            // COPY state
            inversion_bit <= 1'b0;    // inversion_bit low initially
        end else begin
            state <= next_state;
            inversion_bit <= next_inversion_bit;
        end
    end

    // Next state and inversion bit logic combined
    always_comb begin
        case (state)
            1'b0: begin // COPY state: pass bits until first '1'
                if (x_reg) begin
                    next_state = 1'b1;           // transition to INVERT
                    next_inversion_bit = 1'b1;  // inversion_bit set
                end else begin
                    next_state = 1'b0;
                    next_inversion_bit = 1'b0;
                end
            end

            1'b1: begin // INVERT state: always invert bits
                next_state = 1'b1;
                next_inversion_bit = 1'b1;
            end

            default: begin
                next_state = 1'b0;
                next_inversion_bit = 1'b0;
            end
        endcase
    end

    // Output z combinationally depends on registered x and inversion_bit (Moore output)
    assign z = x_reg ^ inversion_bit;

endmodule
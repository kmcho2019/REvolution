module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

// State encoding
localparam [2:0]
    S_A  = 3'd0, // Reset state, wait for reset release
    S_B  = 3'd1, // Output f=1 for one clock cycle (after resetn=1)
    S_C0 = 3'd2, // Wait for x=1 (start sequence)
    S_C1 = 3'd3, // Wait for x=0 (second step)
    S_C2 = 3'd4, // Wait for x=1 (third step)
    S_D  = 3'd5, // g=1, monitor y for 2 cycles
    S_E  = 3'd6, // g=1 permanently
    S_F  = 3'd7; // g=0 permanently

reg [2:0] state, next_state;
reg [1:0] y_counter;

// Sequential block: state transitions, outputs, and y_counter update
always @(posedge clk) begin
    if (!resetn) begin
        state <= S_A;
        f <= 1'b0;
        g <= 1'b0;
        y_counter <= 2'd0;
    end else begin
        state <= next_state;

        // Outputs depend on current state (not next_state)
        case(state)
            S_A: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end

            S_B: begin
                f <= 1'b1;    // f=1 for one cycle immediately after reset release
                g <= 1'b0;
                y_counter <= 2'd0;
            end

            S_C0, S_C1, S_C2: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end

            S_D: begin
                f <= 1'b0;
                g <= 1'b1;
                // Increment y_counter each cycle in S_D
                y_counter <= y_counter + 1'b1;
            end

            S_E: begin
                f <= 1'b0;
                g <= 1'b1;
                // Hold y_counter stable (not used anymore)
                y_counter <= y_counter;
            end

            S_F: begin
                f <= 1'b0;
                g <= 1'b0;
                // Hold y_counter stable (not used anymore)
                y_counter <= y_counter;
            end

            default: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end
        endcase
    end
end

// Combinational logic for next state
always @(*) begin
    next_state = state; // Default hold

    case(state)
        S_A: begin
            // Wait for resetn deassertion
            if (resetn)
                next_state = S_B; // After reset released, move to f=1 pulse state
            else
                next_state = S_A;
        end

        S_B: begin
            // After one cycle f=1, move to sequence detection start
            next_state = S_C0;
        end

        S_C0: begin
            // Wait for x=1 (start of sequence)
            if (x == 1'b1)
                next_state = S_C1;
            else
                next_state = S_C0;
        end

        S_C1: begin
            // Wait for x=0 (second bit)
            if (x == 1'b0)
                next_state = S_C2;
            else // x==1, stay here waiting for 0
                next_state = S_C1;
        end

        S_C2: begin
            // Wait for x=1 (third bit)
            if (x == 1'b1)
                next_state = S_D; // Sequence detected
            else // Restart sequence detection if broken
                next_state = S_C0;
        end

        S_D: begin
            // Monitor y for two cycles using y_counter (0 and 1)
            if (y == 1'b1) begin
                next_state = S_E; // y=1 detected; hold g=1
            end else if (y_counter == 2'd1) begin
                // After two cycles without y=1
                next_state = S_F; // hold g=0 permanently
            end else begin
                next_state = S_D; // keep monitoring y
            end
        end

        S_E: begin
            // Hold g=1 permanently until reset
            next_state = S_E;
        end

        S_F: begin
            // Hold g=0 permanently until reset
            next_state = S_F;
        end

        default: next_state = S_A;
    endcase
end

endmodule
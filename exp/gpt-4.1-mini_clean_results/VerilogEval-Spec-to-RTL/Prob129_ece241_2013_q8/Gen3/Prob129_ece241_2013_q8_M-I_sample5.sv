module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding: 3 states with 3 bits
    localparam S0 = 3'b001; // Initial state, waiting for '1'
    localparam S1 = 3'b010; // Received '1', waiting for '0'
    localparam S2 = 3'b100; // Received "10", waiting for '1'

    reg [2:0] state, next_state;
    reg z_next;

    // State register with async negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;
        end
    end

    // Next state and output combinational logic
    always @(*) begin
        // Default assignments
        next_state = S0;
        z_next = 1'b0;

        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
                z_next = 1'b0;
            end
            S1: begin
                if (~x)
                    next_state = S2;
                else
                    next_state = S1;
                z_next = 1'b0;
            end
            S2: begin
                if (x) begin
                    next_state = S1; // overlap: last '1' starts next sequence
                    z_next = 1'b1;   // sequence "101" detected
                end else begin
                    next_state = S0;
                    z_next = 1'b0;
                end
            end
            default: begin
                next_state = S0;
                z_next = 1'b0;
            end
        endcase
    end

endmodule
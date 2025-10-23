module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Zero-padded extended vector to simplify neighbor access:
    wire [513:0] q_ext;
    assign q_ext = {1'b0, q, 1'b0};

    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            wire [2:0] neighbors;
            assign neighbors = {q_ext[i+2], q_ext[i+1], q_ext[i]}; 
            // neighbors = {left, center, right} per problem definition

            // LUT implementation of Rule 110: next_state = rule110[neighbors]
            // Rule 110 truth table (from problem):
            // Left Center Right | Next
            // 111 (7)           | 0
            // 110 (6)           | 1
            // 101 (5)           | 1
            // 100 (4)           | 0
            // 011 (3)           | 1
            // 010 (2)           | 1
            // 001 (1)           | 1
            // 000 (0)           | 0

            // Define a function to implement rule110 LUT
            function rule110;
                input [2:0] pattern;
                begin
                    case(pattern)
                        3'b111: rule110 = 1'b0;
                        3'b110: rule110 = 1'b1;
                        3'b101: rule110 = 1'b1;
                        3'b100: rule110 = 1'b0;
                        3'b011: rule110 = 1'b1;
                        3'b010: rule110 = 1'b1;
                        3'b001: rule110 = 1'b1;
                        3'b000: rule110 = 1'b0;
                        default: rule110 = 1'b0;
                    endcase
                end
            endfunction

            assign next_state[i] = rule110(neighbors);
        end
    endgenerate

    // Clock gating signal: update next_state only when load is low
    wire update_enable = ~load;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (update_enable) begin
            q <= next_state;
        end
    end

endmodule
module TopModule (
    input wire clk,
    input wire load,
    input wire [511:0] data,
    output wire [511:0] q
);

    reg [511:0] state;

    // Boundary padding: create a 514-bit vector with zeros on both ends
    wire [513:0] padded_state = {1'b0, state, 1'b0};

    // Next state computation as combinational logic in always_comb block
    reg [511:0] next_state;
    integer i;
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            // Extract neighbors
            // left = padded_state[i+2]
            // center = padded_state[i+1]
            // right = padded_state[i]
            // Apply Rule 110: next = (~left & center) | (center ^ right);
            next_state[i] = (~padded_state[i+2] & padded_state[i+1]) | 
                            (padded_state[i+1] ^ padded_state[i]);
        end
    end

    // Sequential update of state
    always @(posedge clk) begin
        if (load)
            state <= data;
        else
            state <= next_state;
    end

    assign q = state;

endmodule
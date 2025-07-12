module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Prediction registers
reg [3:0] carry_propagate;
reg direction_stable;
reg prev_up_down;

// Carry generation wires
wire [15:0] carry_chain;
wire [15:0] sum_bits;
wire [15:0] operand_b = up_down ? 16'h0001 : 16'hFFFF;

// Parallel prefix carry computation
assign carry_chain[0] = (count[0] & operand_b[0]) | (count[0] ^ operand_b[0]);
generate
    genvar i;
    for (i = 1; i < 16; i = i + 1) begin : carry_gen
        assign carry_chain[i] = (count[i] & operand_b[i]) | 
                              ((count[i] ^ operand_b[i]) & carry_chain[i-1]);
    end
endgenerate

// Sum computation with carry-skip optimization
assign sum_bits = count ^ operand_b ^ {carry_chain[14:0], 1'b0};

// Direction stability detection
always @(posedge clk) begin
    prev_up_down <= up_down;
    direction_stable <= (prev_up_down == up_down);
end

// Carry propagate segments
always @(*) begin
    carry_propagate[0] = &(count[3:0]  ^ {4{up_down}});
    carry_propagate[1] = &(count[7:4]  ^ {4{up_down}});
    carry_propagate[2] = &(count[11:8] ^ {4{up_down}});
    carry_propagate[3] = &(count[15:12]^ {4{up_down}});
end

// Main counter logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        if (direction_stable) begin
            // Fast path - skip full carry computation
            if (carry_propagate[0]) count[3:0]   <= up_down ? 4'b0000 : 4'b1111;
            if (carry_propagate[1]) count[7:4]   <= up_down ? 4'b0000 : 4'b1111;
            if (carry_propagate[2]) count[11:8]  <= up_down ? 4'b0000 : 4'b1111;
            if (carry_propagate[3]) count[15:12] <= up_down ? 4'b0000 : 4'b1111;
        end
        // Always update LSBs and non-propagating bits
        count <= sum_bits;
    end
end

endmodule
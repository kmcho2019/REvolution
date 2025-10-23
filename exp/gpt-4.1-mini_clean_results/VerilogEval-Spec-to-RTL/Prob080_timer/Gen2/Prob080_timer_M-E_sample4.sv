module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    // Single D flip-flop holding timer active flag
    reg active;

    // Combinational decrement with ripple borrow
    wire [9:0] next_count;
    wire borrow_out;
    reg [9:0] count_reg;  // combinational register, updated from next_count when active or loaded

    // Ripple borrow logic for decrement: next_count = count_reg - 1 if active and not loaded
    // If load=1, next_count = data

    // Ripple borrow one decrement
    wire borrow_chain [10:0];
    assign borrow_chain[0] = 1'b1; // borrow in for subtracting 1

    genvar i;
    generate
        for(i=0; i<10; i=i+1) begin : DEC10
            // next_count bit = count_reg[i] xor borrow_in
            // borrow_out = (~count_reg[i]) & borrow_in
            assign next_count[i] = (load) ? data[i] : 
                                   (active ? (count_reg[i] ^ borrow_chain[i]) : count_reg[i]);
            assign borrow_chain[i+1] = (active) ? ((~count_reg[i]) & borrow_chain[i]) : 1'b0;
        end
    endgenerate

    // On clock, update count_reg from next_count
    // This is combinational logic feeding the reg, but count_reg holds the count between clocks.
    always @(posedge clk) begin
        if(load) begin
            count_reg <= data;
            active <= 1'b1;          // Timer starts counting
        end else if(active) begin
            if(count_reg != 10'd0) begin
                count_reg <= next_count;
            end else begin
                active <= 1'b0;      // Count reached zero, stop timer
            end
        end
    end

    // Terminal count asserted when timer inactive (count reached zero)
    assign tc = ~active;

endmodule
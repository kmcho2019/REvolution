module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] Y; // next state register

    // Optimized next state bit computations (combinational)
    wire ns2 = ( (y == 3'b001) && x ) || ( (y == 3'b100) && x );
    wire ns1 = ( (y == 3'b010) && ~x ) || ( (y == 3'b011) && x ) || ( (y == 3'b100) && ~x );
    wire y_000_or_010 = (y == 3'b000) || (y == 3'b010);
    wire ns0 = y_000_or_010 ? x : ~x;

    wire [2:0] next_state = {ns2, ns1, ns0};

    // Update next state register synchronously on clk rising edge
    always @(posedge clk) begin
        Y <= next_state;
    end

    // Output Y0 is the LSB of the next state register
    assign Y0 = Y[0];

    // Output z depends on present state y: high only for states 011 or 100
    assign z = ( (y == 3'b011) || (y == 3'b100) );

endmodule
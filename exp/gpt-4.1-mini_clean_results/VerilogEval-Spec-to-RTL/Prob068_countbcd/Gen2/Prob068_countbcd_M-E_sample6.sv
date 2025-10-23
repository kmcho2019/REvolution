module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Extract each digit from q
    wire [3:0] ones   = q[3:0];
    wire [3:0] tens   = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Variables for next state calculation
    reg [15:0] next_q;
    reg [2:0] next_ena;

    // Function to increment a BCD digit and detect carry
    function automatic [4:0] bcd_increment;
        input [3:0] digit_in;
        reg [4:0] result; // 4 bits digit + 1 bit carry
        begin
            if (digit_in == 4'd9) begin
                result = {1'b1, 4'd0}; // carry=1, digit=0
            end else begin
                result = {1'b0, digit_in + 4'd1};
            end
            bcd_increment = result;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            // Increment ones digit
            reg [4:0] ones_inc = bcd_increment(ones);
            // Increment tens digit if ones carry
            reg [4:0] tens_inc = bcd_increment(tens);
            // Increment hundreds digit if tens carry
            reg [4:0] hundreds_inc = bcd_increment(hundreds);
            // Increment thousands digit if hundreds carry
            reg [4:0] thousands_inc = bcd_increment(thousands);

            // Chain increments based on carry propagation
            reg [3:0] ones_next = ones_inc[3:0];
            reg [3:0] tens_next;
            reg [3:0] hundreds_next;
            reg [3:0] thousands_next;

            reg carry1 = ones_inc[4];
            reg carry2;
            reg carry3;
            reg carry4;

            if (carry1)
                tens_inc = bcd_increment(tens);
            tens_next = carry1 ? tens_inc[3:0] : tens;
            carry2 = carry1 ? tens_inc[4] : 1'b0;

            if (carry2)
                hundreds_inc = bcd_increment(hundreds);
            hundreds_next = carry2 ? hundreds_inc[3:0] : hundreds;
            carry3 = carry2 ? hundreds_inc[4] : 1'b0;

            if (carry3)
                thousands_inc = bcd_increment(thousands);
            thousands_next = carry3 ? thousands_inc[3:0] : thousands;
            carry4 = carry3 ? thousands_inc[4] : 1'b0;

            // Assemble next_q
            next_q = {thousands_next, hundreds_next, tens_next, ones_next};

            // ena bits: ena[0] = increment tens (carry from ones)
            //           ena[1] = increment hundreds (carry from tens)
            //           ena[2] = increment thousands (carry from hundreds)
            next_ena = {carry3, carry2, carry1};

            // Update registers
            q <= next_q;
            ena <= next_ena;
        end
    end

endmodule
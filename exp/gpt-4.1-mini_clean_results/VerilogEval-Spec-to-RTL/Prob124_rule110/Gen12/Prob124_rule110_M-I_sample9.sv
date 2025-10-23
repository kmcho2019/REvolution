module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function implementing Rule 110 on a 3-bit neighborhood
    function automatic rule110_cell;
        input [2:0] nbr; // {left, center, right}
        begin
            // Rule 110 truth table in binary: bits correspond to input patterns 111..000
            // The bit positions correspond to {left,center,right} interpreted as 3-bit number:
            // For example, input=3'b111 (7) => output 0, input=3'b110 (6)=>1, etc.
            case (nbr)
                3'b111: rule110_cell = 1'b0;
                3'b110: rule110_cell = 1'b1;
                3'b101: rule110_cell = 1'b1;
                3'b100: rule110_cell = 1'b0;
                3'b011: rule110_cell = 1'b1;
                3'b010: rule110_cell = 1'b1;
                3'b001: rule110_cell = 1'b1;
                3'b000: rule110_cell = 1'b0;
                default: rule110_cell = 1'b0;
            endcase
        end
    endfunction

    reg [513:0] padded_q; // padded state for boundary zero padding

    integer i;
    reg [511:0] next_state;

    always @(*) begin
        padded_q[0] = 1'b0;           // left boundary zero
        padded_q[513] = 1'b0;         // right boundary zero
        padded_q[512:1] = q;          // copy current state into padded vector

        for (i = 0; i < 512; i = i + 1) begin
            // neighbors: left = padded_q[i+2], center = padded_q[i+1], right = padded_q[i]
            next_state[i] = rule110_cell({padded_q[i+2], padded_q[i+1], padded_q[i]});
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
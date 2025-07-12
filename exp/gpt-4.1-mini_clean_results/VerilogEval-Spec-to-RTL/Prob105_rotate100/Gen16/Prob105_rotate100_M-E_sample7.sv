module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output reg [99:0] q
);

    // Internal storage: 100-bit circular buffer as array of bits
    reg [0:99] buffer;  // Use index [0]..[99] for convenience
    reg [6:0]  ptr;     // Pointer/index: 0..99 (7 bits to cover 100)

    // Next pointer calculation with wrap-around
    wire rotate_left  = (ena == 2'b10);
    wire rotate_right = (ena == 2'b01);

    wire [6:0] ptr_inc = (ptr == 7'd99) ? 7'd0 : ptr + 7'd1;
    wire [6:0] ptr_dec = (ptr == 7'd0)  ? 7'd99 : ptr - 7'd1;

    // On clock: load buffer and reset pointer, or rotate pointer, or hold
    always @(posedge clk) begin
        if (load) begin
            // Load data bits into buffer (reverse indexing since data[99] is MSB)
            // buffer[0] = data[0], ..., buffer[99] = data[99]
            // We can assign as bits to avoid wide assignment issues.
            integer i;
            for (i = 0; i < 100; i = i + 1)
                buffer[i] <= data[i];
            ptr <= 7'd0;
        end else if (rotate_left) begin
            ptr <= ptr_inc;
        end else if (rotate_right) begin
            ptr <= ptr_dec;
        end else begin
            // Hold ptr and buffer
            // buffer unchanged
            ptr <= ptr;
        end
    end

    // Combinational logic to assemble output q from circular buffer and ptr
    // q[99] = buffer[(ptr + 99) mod 100], q[0] = buffer[ptr]
    // Since q is reg output, assign in combinational block using an intermediate wire
    integer j;
    always @* begin
        for (j = 0; j < 100; j = j + 1) begin
            // Compute circular index with wrap-around
            // index = (ptr + j) % 100
            // q[j] corresponds to buffer at (ptr + j) mod 100
            // But problem states q is output of rotator; the output should show the rotated data
            // If we consider q[0] is LSB, then:
            // q[j] = buffer[(ptr + j) mod 100]
            // This matches logical rotation by ptr
            // Output is aligned with buffer shifted by ptr to left logically
            // This matches definition:
            // Rotate left = increment ptr, so q shifts bits left logically
            q[j] = buffer[(ptr + j) % 100];
        end
    end

endmodule
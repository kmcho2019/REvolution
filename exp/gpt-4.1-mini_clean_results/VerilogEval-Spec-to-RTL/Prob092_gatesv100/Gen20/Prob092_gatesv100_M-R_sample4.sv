module TopModule(
    input  wire [99:0] in,
    output reg  [99:0] out_both,
    output reg  [99:0] out_any,
    output reg  [99:0] out_different
);

    integer i;

    always @(*) begin
        // Initialize outputs for boundary bits per specs
        out_both[99]      = 1'b0; // no left neighbor for bit 99
        out_any[0]        = 1'b0; // no right neighbor for bit 0

        for (i = 0; i < 99; i = i + 1) begin
            // out_both[i] = in[i] & in[i+1]
            out_both[i] = in[i] & in[i+1];
            // out_any[i+1] = in[i+1] | in[i]
            out_any[i+1] = in[i+1] | in[i];
        end

        for (i = 0; i < 100; i = i + 1) begin
            // left neighbor index with wrap-around
            // neighbor to the left of i is (i == 99) ? 0 : i+1
            integer left_neighbor;
            left_neighbor = (i == 99) ? 0 : i + 1;
            out_different[i] = in[i] ^ in[left_neighbor];
        end
    end

endmodule
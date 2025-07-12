module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute Rule 110 next state for the entire 512-bit vector
    function automatic [511:0] rule110_next_state(
        input [511:0] current
    );
        integer idx;
        reg left, center, right;
        reg [511:0] result;
        begin
            for (idx = 0; idx < 512; idx = idx + 1) begin
                // Define neighbors with zero boundary padding
                left = (idx == 511) ? 1'b0 : current[idx+1];
                center = current[idx];
                right = (idx == 0) ? 1'b0 : current[idx-1];
                // Apply Rule 110: next = (~left & center) | (center ^ right)
                result[idx] = (~left & center) | (center ^ right);
            end
            rule110_next_state = result;
        end
    endfunction

    reg [511:0] next_q;

    // Compute next_q combinationally from current q
    always @(*) begin
        next_q = rule110_next_state(q);
    end

    // Sequential logic: on clock edge load or update state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_state;
    reg [2:0] window;  // [left, center, right]
    reg [8:0] counter; // 0-511 counter
    reg computing;

    // Rule 110 computation
    wire next_bit;
    assign next_bit = (window[2] & window[1] & ~window[0]) |  // 110
                     (window[2] & ~window[1] & window[0]) |   // 101
                     (~window[2] & window[1]) |               // 011 or 010
                     (~window[2] & window[0]);               // 001

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            counter <= 0;
            computing <= 0;
        end else begin
            if (!computing) begin
                // Start new computation cycle
                next_state <= 0;
                window <= {q[510], q[511], 1'b0}; // Initialize for bit 511
                counter <= 1;
                computing <= 1;
            end else begin
                if (counter < 512) begin
                    // Shift in next bit (right neighbor)
                    window <= {window[1:0], (counter == 511) ? 1'b0 : q[511-counter]};
                    
                    // Store computed bit
                    next_state[511-counter+1] <= next_bit;
                    
                    counter <= counter + 1;
                end else begin
                    // Final bit computation
                    next_state[0] <= next_bit;
                    
                    // Update output and end computation
                    q <= next_state;
                    computing <= 0;
                end
            end
        end
    end

endmodule
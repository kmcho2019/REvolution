module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [2:0] stage;  // Pipeline stage counter (0-15)
reg [511:0] next_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
        stage <= 0;
    end else begin
        if (stage == 0) begin
            // First stage: process cells 0-31
            next_q[0] <= 0 ^ q[1];
            for (integer i = 1; i < 31; i = i + 1) begin
                next_q[i] <= q[i-1] ^ q[i+1];
            end
            next_q[31] <= q[30] ^ q[32];
            stage <= stage + 1;
        end
        else if (stage < 15) begin
            // Middle stages: process blocks of 32 cells
            integer start = stage * 32;
            integer end_cell = start + 31;
            for (integer i = start; i <= end_cell; i = i + 1) begin
                if (i == start)
                    next_q[i] <= q[i-1] ^ q[i+1];
                else if (i == end_cell)
                    next_q[i] <= q[i-1] ^ q[i+1];
                else
                    next_q[i] <= q[i-1] ^ q[i+1];
            end
            stage <= stage + 1;
        end
        else begin
            // Final stage: process cells 480-511
            next_q[480] <= q[479] ^ q[481];
            for (integer i = 481; i < 511; i = i + 1) begin
                next_q[i] <= q[i-1] ^ q[i+1];
            end
            next_q[511] <= q[510] ^ 0;
            
            // Update the full state and reset pipeline
            q <= next_q;
            stage <= 0;
        end
    end
end

endmodule
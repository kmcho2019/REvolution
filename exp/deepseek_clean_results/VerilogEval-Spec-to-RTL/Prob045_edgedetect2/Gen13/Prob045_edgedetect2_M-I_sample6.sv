module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    parameter STABLE_THRESHOLD = 2; // Number of cycles input must be stable to disable updates
    reg [7:0] prev_in;
    reg [1:0] stable_count = 0;
    wire input_stable = (in == prev_in);
    wire enable_updates = (stable_count < STABLE_THRESHOLD) || !input_stable;

    always @(posedge clk) begin
        if (enable_updates) begin
            anyedge <= in ^ prev_in;
            prev_in <= in;
        end else begin
            anyedge <= 8'b0; // Clear output when inputs are stable
        end

        // Update stability counter
        if (input_stable) begin
            stable_count <= (stable_count < STABLE_THRESHOLD) ? stable_count + 1 : stable_count;
        end else begin
            stable_count <= 0;
        end
    end

endmodule
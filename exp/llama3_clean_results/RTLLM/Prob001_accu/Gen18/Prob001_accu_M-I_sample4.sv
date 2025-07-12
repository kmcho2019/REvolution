module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] cnt;
reg [9:0] sum;
reg enable_clk; // Clock enable signal for clock gating

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        sum <= 0;
        enable_clk <= 0;
    end else begin
        if (valid_in) begin
            enable_clk <= 1; // Enable clock when valid input is present
            if (cnt < 4) begin
                sum <= sum + data_in;
                cnt <= cnt + 1;
            end else begin
                // Reset sum and counter when 4 inputs are accumulated
                sum <= 0;
                cnt <= 0;
            end
        end else begin
            enable_clk <= 0; // Disable clock when no valid input
            if (cnt == 0) begin
                sum <= 0; // Reset sum when no accumulation is happening
            end
        end
    end
end

// Clock gating
wire clk_gated = clk & enable_clk;

// Accumulator and counter update using the gated clock
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        // No additional logic needed here as the main logic handles resets
    end
end

assign valid_out = (cnt == 0) && (sum != 0);
assign data_out = sum;

endmodule
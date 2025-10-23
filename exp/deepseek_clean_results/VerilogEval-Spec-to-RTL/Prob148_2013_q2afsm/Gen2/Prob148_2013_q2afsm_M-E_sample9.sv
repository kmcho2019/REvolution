module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Internal signals
    wire [2:0] next_g;

    // Priority-based grant assignment
    assign next_g[0] = (g[0] & r[0]) |        // Maintain if still requesting
                     (~|g & r[0]);           // New grant if no current grants

    assign next_g[1] = (g[1] & r[1]) |        // Maintain if still requesting
                     (~|g & ~r[0] & r[1]);   // New grant if no higher priority

    assign next_g[2] = (g[2] & r[2]) |        // Maintain if still requesting
                     (~|g & ~r[0] & ~r[1] & r[2]); // New grant if only request

    // Registered output with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            g <= 3'b000;
        end else begin
            // Only one grant can be active at a time
            if (next_g[0]) g <= 3'b001;
            else if (next_g[1]) g <= 3'b010;
            else if (next_g[2]) g <= 3'b100;
            else g <= 3'b000;
        end
    end

endmodule
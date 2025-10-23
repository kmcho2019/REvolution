module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] stable_counter;  // Counter for input stability
    wire clk_en;               // Clock enable signal

    // Clock gating control
    assign clk_en = (|(in ^ prev_in)) || (stable_counter < 3'b111);

    always @(posedge clk) begin
        if (clk_en) begin
            prev_in <= in;
            anyedge <= in ^ prev_in;
        end

        // Update stability counter
        if (in == prev_in) begin
            stable_counter <= (stable_counter < 3'b111) ? stable_counter + 1 : stable_counter;
        end else begin
            stable_counter <= 0;
        end
    end

endmodule
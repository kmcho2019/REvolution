module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

    // Split q into 4 BCD digits
    wire [3:0] ones   = q[3:0];
    wire [3:0] tens   = q[7:4];
    wire [3:0] hundreds = q[11:8];
    wire [3:0] thousands = q[15:12];

    // Internal registers to hold digits
    reg [3:0] ones_r, tens_r, hundreds_r, thousands_r;
    reg ena_0, ena_1, ena_2;

    always @(posedge clk) begin
        if (reset) begin
            ones_r <= 4'd0;
            tens_r <= 4'd0;
            hundreds_r <= 4'd0;
            thousands_r <= 4'd0;
            ena_0 <= 1'b0;
            ena_1 <= 1'b0;
            ena_2 <= 1'b0;
        end else begin
            // Default ena to 0
            ena_0 <= 1'b0;
            ena_1 <= 1'b0;
            ena_2 <= 1'b0;

            // Increment ones digit
            if (ones_r == 4'd9) begin
                ones_r <= 4'd0;
                ena_0 <= 1'b1; // Enable tens digit
            end else begin
                ones_r <= ones_r + 4'd1;
            end

            // Increment tens digit if enabled by ones digit rollover
            if (ena_0) begin
                if (tens_r == 4'd9) begin
                    tens_r <= 4'd0;
                    ena_1 <= 1'b1; // Enable hundreds digit
                end else begin
                    tens_r <= tens_r + 4'd1;
                end
            end

            // Increment hundreds digit if enabled by tens digit rollover
            if (ena_1) begin
                if (hundreds_r == 4'd9) begin
                    hundreds_r <= 4'd0;
                    ena_2 <= 1'b1; // Enable thousands digit
                end else begin
                    hundreds_r <= hundreds_r + 4'd1;
                end
            end

            // Increment thousands digit if enabled by hundreds digit rollover
            if (ena_2) begin
                if (thousands_r == 4'd9) begin
                    thousands_r <= 4'd0;
                end else begin
                    thousands_r <= thousands_r + 4'd1;
                end
            end
        end
    end

    // Combine digits back into q and ena output
    always @(*) begin
        q = {thousands_r, hundreds_r, tens_r, ones_r};
        ena = {ena_2, ena_1, ena_0};
    end

endmodule
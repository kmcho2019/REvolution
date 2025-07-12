module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] cnt;
    reg [7:0] shift_reg;
    reg din_valid_reg;
    wire full;

    // Register input valid signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            din_valid_reg <= 1'b0;
        end else begin
            din_valid_reg <= din_valid;
        end
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
        end else if (din_valid_reg) begin
            cnt <= (full) ? 3'b0 : cnt + 1;
        end
    end

    // Shift register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
        end else if (din_valid_reg) begin
            shift_reg <= {din_serial, shift_reg[7:1]};
        end
    end

    // Output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
        end else if (full && din_valid_reg) begin
            dout_parallel <= {din_serial, shift_reg[7:1]};
        end
    end

    // Combinational outputs
    assign full = (cnt == 3'd7);
    assign dout_valid = full && din_valid_reg;

endmodule
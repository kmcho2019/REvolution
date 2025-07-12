module BCD_Digit_Control (
    input clk,
    input reset,
    input [3:0] value,
    input en_in,
    output reg en_out,
    output reg [3:0] next_value
);

    always @(*) begin
        if (en_in) begin
            if (value == 4'd9) begin
                next_value = 4'd0;
                en_out = 1'b1;
            end else begin
                next_value = value + 1;
                en_out = 1'b0;
            end
        end else begin
            next_value = value;
            en_out = 1'b0;
        end
    end

endmodule

module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] ones_next, tens_next, hundreds_next, thousands_next;
    wire ones_ena, tens_ena, hundreds_ena;
    reg ones_ena_reg, tens_ena_reg, hundreds_ena_reg;
    
    assign q = counter;
    
    // Instantiate control logic for each digit
    BCD_Digit_Control ones_ctrl (
        .clk(clk),
        .reset(reset),
        .value(counter[3:0]),
        .en_in(1'b1),  // Ones digit always enabled
        .en_out(ones_ena),
        .next_value(ones_next)
    );
    
    BCD_Digit_Control tens_ctrl (
        .clk(clk),
        .reset(reset),
        .value(counter[7:4]),
        .en_in(ones_ena_reg),
        .en_out(tens_ena),
        .next_value(tens_next)
    );
    
    BCD_Digit_Control hundreds_ctrl (
        .clk(clk),
        .reset(reset),
        .value(counter[11:8]),
        .en_in(tens_ena_reg),
        .en_out(hundreds_ena),
        .next_value(hundreds_next)
    );
    
    BCD_Digit_Control thousands_ctrl (
        .clk(clk),
        .reset(reset),
        .value(counter[15:12]),
        .en_in(hundreds_ena_reg),
        .en_out(),  // No higher digit to enable
        .next_value(thousands_next)
    );
    
    // Register enable signals to break critical path
    always @(posedge clk) begin
        if (reset) begin
            ones_ena_reg <= 1'b0;
            tens_ena_reg <= 1'b0;
            hundreds_ena_reg <= 1'b0;
        end else begin
            ones_ena_reg <= ones_ena;
            tens_ena_reg <= tens_ena;
            hundreds_ena_reg <= hundreds_ena;
        end
    end
    
    // Output registered enable signals
    assign ena = {hundreds_ena_reg, tens_ena_reg, ones_ena_reg};
    
    // Update counter with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            counter[3:0] <= ones_next;
            if (ones_ena_reg) counter[7:4] <= tens_next;
            if (tens_ena_reg) counter[11:8] <= hundreds_next;
            if (hundreds_ena_reg) counter[15:12] <= thousands_next;
        end
    end

endmodule
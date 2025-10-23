module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [1:0] state; // control part (binary encoding)
reg [2:0] output_state; // output part (one-hot encoding)
reg clk_en; // clock enable signal

// control part
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // synchronous active high reset
    end else begin
        case (state)
            2'b00: state <= x? 2'b01 : 2'b00;
            2'b01: state <= x? 2'b10 : 2'b01;
            2'b10: state <= x? 2'b10 : 2'b01;
            default: state <= 2'b00;
        endcase
    end
end

// output part
always @(posedge clk) begin
    if (reset) begin
        output_state <= 3'b001; // synchronous active high reset
    end else begin
        case (state)
            2'b00: output_state <= x? 3'b001 : 3'b001;
            2'b01: output_state <= x? 3'b100 : 3'b001;
            2'b10: output_state <= x? 3'b010 : 3'b001;
            default: output_state <= 3'b001;
        endcase
    end
end

// output logic
always @(*) begin
    case (output_state)
        3'b001: z = 1'b0;
        3'b010: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// clock-disable logic
always @(*) begin
    if (state == 2'b00 && x == 1'b0) begin
        clk_en = 1'b0; // disable clock when state doesn't change
    end else begin
        clk_en = 1'b1;
    end
end

// use clock enable for state register
always @(posedge clk) begin
    if (clk_en || reset) begin
        // update state and output_state registers
    end
end

endmodule
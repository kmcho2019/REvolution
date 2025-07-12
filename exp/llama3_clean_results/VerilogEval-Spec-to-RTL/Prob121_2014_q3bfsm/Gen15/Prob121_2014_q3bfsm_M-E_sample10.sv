module StateDecoder(
    input [2:0] y,
    output reg [7:0] one_hot_state
);

always @(*) begin
    case (y)
        3'b000: one_hot_state = 8'b00000001;
        3'b001: one_hot_state = 8'b00000010;
        3'b010: one_hot_state = 8'b00000100;
        3'b011: one_hot_state = 8'b00001000;
        3'b100: one_hot_state = 8'b00010000;
        default: one_hot_state = 8'b00000001;
    endcase
end

endmodule

module TransitionController(
    input [7:0] one_hot_state,
    input x,
    output reg [7:0] next_one_hot_state
);

always @(*) begin
    case (one_hot_state)
        8'b00000001: next_one_hot_state = x? 8'b00000010 : 8'b00000001;
        8'b00000010: next_one_hot_state = x? 8'b00010000 : 8'b00000010;
        8'b00000100: next_one_hot_state = x? 8'b00000010 : 8'b00000100;
        8'b00001000: next_one_hot_state = x? 8'b00000100 : 8'b00000010;
        8'b00010000: next_one_hot_state = x? 8'b00010000 : 8'b00001000;
        default: next_one_hot_state = 8'b00000001;
    endcase
end

endmodule

module OutputGenerator(
    input [7:0] one_hot_state,
    output reg z
);

always @(*) begin
    case (one_hot_state)
        8'b00001000: z = 1'b1;
        8'b00010000: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [7:0] one_hot_state; // one-hot encoded current state
reg [7:0] next_one_hot_state; // one-hot encoded next state
reg clk_en; // clock enable signal

StateDecoder state_decoder(
   .y(y),
   .one_hot_state(one_hot_state)
);

TransitionController transition_controller(
   .one_hot_state(one_hot_state),
   .x(x),
   .next_one_hot_state(next_one_hot_state)
);

OutputGenerator output_generator(
   .one_hot_state(one_hot_state),
   .z(z)
);

// Clock gating logic
always @(*) begin
    if (one_hot_state == next_one_hot_state) begin
        clk_en = 1'b0; // Disable clock if state doesn't change
    end else begin
        clk_en = 1'b1;
    end
end

// Use clock enable for state register
always @(posedge clk) begin
    if (clk_en || reset) begin
        if (reset) begin
            y <= 3'b000; // synchronous active high reset
        end else begin
            y <= get_state_from_one_hot(next_one_hot_state);
        end
    end
end

// Function to convert one-hot encoded state to binary state
function [2:0] get_state_from_one_hot;
input [7:0] one_hot_state;
begin
    case (one_hot_state)
        8'b00000001: get_state_from_one_hot = 3'b000;
        8'b00000010: get_state_from_one_hot = 3'b001;
        8'b00000100: get_state_from_one_hot = 3'b010;
        8'b00001000: get_state_from_one_hot = 3'b011;
        8'b00010000: get_state_from_one_hot = 3'b100;
        default: get_state_from_one_hot = 3'b000;
    endcase
end
endfunction

endmodule
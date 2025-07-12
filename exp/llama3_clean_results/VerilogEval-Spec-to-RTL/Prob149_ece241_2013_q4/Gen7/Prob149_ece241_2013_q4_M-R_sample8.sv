module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

// State machine
reg [1:0] state;
reg [1:0] next_state;

// Define the states
localparam LOW = 2'b00;
localparam MIDDLE = 2'b01;
localparam HIGH = 2'b10;

// State machine transitions
always @(posedge clk) begin
    if (reset) begin
        state <= LOW;
        prev_s <= 3'b000;
    end else begin
        state <= next_state;
        prev_s <= s;
    end
end

// Determine the next state
always @(*) begin
    case (state)
        LOW: begin
            if (s == 3'b000) begin
                next_state <= LOW;
            end else if (s == 3'b001) begin
                next_state <= MIDDLE;
            end else begin
                next_state <= MIDDLE;
            end
        end
        MIDDLE: begin
            if (s == 3'b000) begin
                next_state <= LOW;
            end else if (s == 3'b001 || s == 3'b010 || s == 3'b011 || s == 3'b100 || s == 3'b110) begin
                next_state <= MIDDLE;
            end else if (s == 3'b111) begin
                next_state <= HIGH;
            end
        end
        HIGH: begin
            if (s == 3'b111) begin
                next_state <= HIGH;
            end else if (s == 3'b000 || s == 3'b001 || s == 3'b010 || s == 3'b011 || s == 3'b100 || s == 3'b110) begin
                next_state <= MIDDLE;
            end else begin
                next_state <= MIDDLE;
            end
        end
        default: begin
            next_state <= LOW;
        end
    endcase
end

// Determine the output signals
assign fr2 = (state == LOW || state == MIDDLE && (s == 3'b100 || s == 3'b110 || s == 3'b001))? 1'b1 : 1'b0;
assign fr1 = (state == LOW || state == MIDDLE && (s == 3'b010 || s == 3'b011 || s == 3'b001))? 1'b1 : 1'b0;
assign fr0 = (state == LOW || state == MIDDLE)? 1'b1 : 1'b0;
assign dfr = (state == MIDDLE && (s > prev_s))? 1'b1 : 1'b0;

endmodule
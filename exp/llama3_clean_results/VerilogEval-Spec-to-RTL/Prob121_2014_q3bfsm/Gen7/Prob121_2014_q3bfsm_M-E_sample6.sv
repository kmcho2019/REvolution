module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] state;
reg [2:0] next_state;
reg [2:0] rom_data;

// ROM to store next state values
always @(*) begin
    case (state)
        3'b000: rom_data = x? 3'b001 : 3'b000;
        3'b001: rom_data = x? 3'b100 : 3'b001;
        3'b010: rom_data = x? 3'b001 : 3'b010;
        3'b011: rom_data = x? 3'b010 : 3'b001;
        3'b100: rom_data = x? 3'b100 : 3'b011;
        default: rom_data = 3'b000;
    endcase
end

// Counter to keep track of current state
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= next_state;
    end
end

// State transition controller
always @(*) begin
    next_state = rom_data;
end

// Output logic
always @(*) begin
    case (state)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule
module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Sequential logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Combinational logic for next state and output
always @ (*) begin
    if (y == 3'b000) begin
        next_state = x? 3'b001 : 3'b000;
    end else if (y == 3'b001) begin
        next_state = x? 3'b100 : 3'b001;
    end else if (y == 3'b010) begin
        next_state = x? 3'b001 : 3'b010;
    end else if (y == 3'b011) begin
        next_state = x? 3'b010 : 3'b001;
    end else if (y == 3'b100) begin
        next_state = x? 3'b100 : 3'b011;
    end else begin
        next_state = 3'b000;
    end
    
    // Directly assign output z based on current state
    z = (y == 3'b011 || y == 3'b100);
end

// Directly assign output Y0 from next_state
assign Y0 = next_state[0];

endmodule
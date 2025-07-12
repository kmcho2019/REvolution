module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

// Define the states
parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

// Declare the current state and next state variables
reg [2:0] y;
reg [2:0] next_y;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Reset the FSM to state 000
        y <= S000;
    end else begin
        // Update the current state
        y <= next_y;
    end
end

// Combinational logic
always @(*) begin
    case (y)
        S000: begin
            if (~x) begin
                next_y = S000;
            end else begin
                next_y = S001;
            end
            z = 0;
        end
        S001: begin
            if (~x) begin
                next_y = S001;
            end else begin
                next_y = S100;
            end
            z = 0;
        end
        S010: begin
            if (~x) begin
                next_y = S010;
            end else begin
                next_y = S001;
            end
            z = 0;
        end
        S011: begin
            if (~x) begin
                next_y = S001;
            end else begin
                next_y = S010;
            end
            z = 1;
        end
        S100: begin
            if (~x) begin
                next_y = S011;
            end else begin
                next_y = S100;
            end
            z = 1;
        end
        default: begin
            next_y = S000;
            z = 0;
        end
    endcase
end

endmodule
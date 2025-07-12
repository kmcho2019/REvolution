module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

// Define states
parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

// Current and next state
reg [2:0] y, y_next;

// Output
reg z_next;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= S000;
    end else begin
        y <= y_next;
    end
end

// Combinational logic for next state
always @* begin
    case (y)
        S000: begin
            if (!x) y_next = S000;
            else y_next = S001;
        end
        S001: begin
            if (!x) y_next = S001;
            else y_next = S100;
        end
        S010: begin
            if (!x) y_next = S010;
            else y_next = S001;
        end
        S011: begin
            if (!x) y_next = S001;
            else y_next = S010;
        end
        S100: begin
            if (!x) y_next = S011;
            else y_next = S100;
        end
        default: y_next = S000; // Default state
    endcase
end

// Combinational logic for output z
always @* begin
    case (y)
        S000, S001, S010: z_next = 1'b0;
        S011, S100: z_next = 1'b1;
        default: z_next = 1'b0; // Default output
    endcase
end

// Output logic
always @(posedge clk) begin
    z <= z_next;
end

endmodule
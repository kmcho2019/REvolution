module TopModule(
    input        clk,
    input        reset,
    input        j,
    input        k,
    output       out
);

reg [0:0] current_state;
reg [0:0] next_state;

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// State register
always @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
    endcase
end

// Output logic
assign out = current_state;

endmodule
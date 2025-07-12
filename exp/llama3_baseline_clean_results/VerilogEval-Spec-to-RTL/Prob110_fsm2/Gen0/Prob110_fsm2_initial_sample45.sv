module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define states
localparam OFF = 1'b0;
localparam ON = 1'b1;

// Current state register
reg current_state;

// Next state logic
always @(*) begin
    if(areset) begin
        current_state = OFF;
    end else if(current_state == OFF) begin
        if(j) begin
            current_state = ON;
        end else begin
            current_state = OFF;
        end
    end else if(current_state == ON) begin
        if(k) begin
            current_state = OFF;
        end else begin
            current_state = ON;
        end
    end
end

// Output logic
assign out = current_state;

endmodule
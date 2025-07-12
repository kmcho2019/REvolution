module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// State encoding:
// 2'b00: initial state, no sequence detected
// 2'b01: "1" detected
// 2'b10: "10" detected

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        2'b00: begin
            if (x) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin
            if (x) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b10;
            end
        end
        2'b10: begin
            if (x) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

// Output logic
assign z = (state == 2'b10) && x;

endmodule
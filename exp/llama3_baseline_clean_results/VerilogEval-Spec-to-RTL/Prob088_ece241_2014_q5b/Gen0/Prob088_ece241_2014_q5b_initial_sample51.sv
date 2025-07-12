module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// One-hot encoding: A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

// Asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @* begin
    case (state)
        A: 
            if (~x) begin
                next_state = A;
                z = 1'b0;
            end else begin
                next_state = B;
                z = 1'b1;
            end
        B: 
            if (~x) begin
                next_state = B;
                z = 1'b1;
            end else begin
                next_state = B;
                z = 1'b0;
            end
        default: begin
            next_state = A;
            z = 1'b0;
        end
    endcase
end

endmodule
module TopModule(
    input clk,
    input areset,
    input x,
    output reg z // Declare 'z' as a reg
);

reg [1:0] current_state;
reg [1:0] next_state;

// One-hot encoding: A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
        z <= 0; // Reset 'z' when 'areset' is high
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    z <= 0; // Default assignment to 'z'
    case (current_state)
        A: begin
            if (x == 0) begin
                next_state <= A;
                z <= 0;
            end else begin
                next_state <= B;
                z <= 1;
            end
        end
        B: begin
            next_state <= B;
            if (x == 0) begin
                z <= 1;
            end else begin
                z <= 0;
            end
        end
        default: begin
            next_state <= A;
        end
    endcase
end

endmodule
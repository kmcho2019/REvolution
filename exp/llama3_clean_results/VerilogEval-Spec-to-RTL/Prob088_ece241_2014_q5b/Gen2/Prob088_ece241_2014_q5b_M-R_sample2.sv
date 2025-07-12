module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// Define states
parameter A = 2'b01;
parameter B = 2'b10;

// Current state
reg [1:0] current_state;

// Initialize current state
initial current_state = A;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (x) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            B: begin
                current_state <= B;
            end
            default: begin
                current_state <= A;
            end
        endcase
    end
end

// Combinational logic for output z
always @* begin
    case (current_state)
        A: begin
            if (x) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
            end
        end
        B: begin
            z = 1'b1;
        end
        default: begin
            z = 1'b0;
        end
    endcase
end

endmodule
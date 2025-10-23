module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Define current and next state
reg [1:0] current_state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else if (r[1] == 1'b1) begin
                next_state <= C;
            end else if (r[2] == 1'b1) begin
                next_state <= D;
            end else begin
                next_state <= A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                next_state <= C;
            end else begin
                next_state <= A;
            end
        end
        D: begin
            // This state is not needed according to the problem description
            next_state <= A;
        end
        default: begin
            next_state <= A;
        end
    endcase
end

// Outputs
always @(*) begin
    case (current_state)
        A: begin
            g <= 3'b000;
        end
        B: begin
            g <= 3'b100;
        end
        C: begin
            g <= 3'b010;
        end
        D: begin
            // This state is not needed according to the problem description
            g <= 3'b001;
        end
        default: begin
            g <= 3'b000;
        end
    endcase
end

endmodule
module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output reg [2:0] g // declare g as a reg variable
);

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Declare the current state variable
reg [1:0] current_state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (r[0]) begin
                    current_state <= B;
                end else if (r[1]) begin
                    current_state <= C;
                end else if (r[2]) begin
                    current_state <= D;
                end else begin
                    current_state <= A;
                end
            end
            B: begin
                if (r[0]) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            C: begin
                if (r[1]) begin
                    current_state <= C;
                end else begin
                    current_state <= A;
                end
            end
            D: begin
                if (r[2]) begin
                    current_state <= D;
                end else begin
                    current_state <= A;
                end
            end
        endcase
    end
end

// Output logic
always @(*) begin
    case (current_state)
        A: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = r[2];
        end
        B: begin
            g[0] = 1'b1;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
        C: begin
            g[0] = 1'b0;
            g[1] = 1'b1;
            g[2] = 1'b0;
        end
        D: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b1;
        end
    endcase
end

endmodule
module TopModule (
    input        clk,
    input        resetn,
    input        x,
    input        y,
    output       f,
    output       g
);

// Define the states
parameter   A = 4'd0, 
            B = 4'd1, 
            C = 4'd2, 
            D = 4'd3, 
            E = 4'd4, 
            F = 4'd5;

reg [3:0] state;
reg [3:0] nextState;
reg [1:0] x_count;
reg [1:0] y_count;

// Set the initial state
initial state = A;

// Set the output f
assign f = (state == B) ? 1'b1 : 1'b0;

// Set the output g
assign g = (state == E) ? 1'b1 : ((state == D && y_count < 2'd2) || state == F) ? 1'b0 : 1'b0;

// State transition logic
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case(state)
            A: begin
                state <= B;
            end
            B: begin
                state <= C;
                x_count <= 0;
            end
            C: begin
                if (x_count == 2'd0 && x == 1'b1) begin
                    x_count <= x_count + 1;
                end else if (x_count == 2'd1 && x == 1'b0) begin
                    x_count <= x_count + 1;
                end else if (x_count == 2'd2 && x == 1'b1) begin
                    state <= D;
                    x_count <= 0;
                    y_count <= 0;
                end else begin
                    x_count <= 0;
                end
            end
            D: begin
                if (y == 1'b1) begin
                    state <= E;
                end else if (y_count < 2'd1) begin
                    y_count <= y_count + 1;
                end else begin
                    state <= F;
                end
            end
            E: begin
                // Stay in this state
            end
            F: begin
                // Stay in this state
            end
            default: state <= A;
        endcase
    end
end

endmodule
module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // state variable
reg [1:0] x_count; // counter for x sequence
reg [1:0] y_count; // counter for y sequence

// Define states
localparam A = 3'b000; // beginning state
localparam B = 3'b001; // set f to 1
localparam C = 3'b010; // wait for x sequence
localparam D = 3'b011; // set g to 1 and wait for y
localparam E = 3'b100; // keep g = 1 permanently
localparam F = 3'b101; // keep g = 0 permanently

// Initialize outputs
assign f = (state == B);
assign g = (state == D || state == E);

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            A: state <= B;
            B: state <= C;
            C: begin
                if (x_count == 0 && x) begin
                    x_count <= x_count + 1;
                end else if (x_count == 1 && !x) begin
                    x_count <= x_count + 1;
                end else if (x_count == 2 && x) begin
                    state <= D;
                    x_count <= 0;
                end else if (x_count == 1 && x) begin
                    x_count <= 1;
                end else if (x_count == 2 && !x) begin
                    x_count <= 0;
                end
            end
            D: begin
                if (y || y_count == 2) begin
                    if (y) begin
                        state <= E;
                    end else begin
                        state <= F;
                    end
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                end
            end
            E, F: ; // stay in the same state
        endcase
    end
end

endmodule
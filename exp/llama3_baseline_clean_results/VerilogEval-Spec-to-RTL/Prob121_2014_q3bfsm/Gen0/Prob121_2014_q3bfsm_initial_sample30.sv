module TopModule(
    input           clk,
    input           reset,
    input           x,
    output          z
);

    reg [2:0] y; // current state
    reg [2:0] next_y; // next state
    wire        z_wire; // output wire

    // Determine next state and output
    always @(*) begin
        case (y)
            3'b000: begin
                if (~x) begin
                    next_y = 3'b000;
                end else begin
                    next_y = 3'b001;
                end
                z_wire = 1'b0;
            end
            3'b001: begin
                if (~x) begin
                    next_y = 3'b001;
                end else begin
                    next_y = 3'b100;
                end
                z_wire = 1'b0;
            end
            3'b010: begin
                if (~x) begin
                    next_y = 3'b010;
                end else begin
                    next_y = 3'b001;
                end
                z_wire = 1'b0;
            end
            3'b011: begin
                if (~x) begin
                    next_y = 3'b001;
                end else begin
                    next_y = 3'b010;
                end
                z_wire = 1'b1;
            end
            3'b100: begin
                if (~x) begin
                    next_y = 3'b011;
                end else begin
                    next_y = 3'b100;
                end
                z_wire = 1'b1;
            end
            default: begin
                next_y = 3'b000; // default next state
                z_wire = 1'b0; // default output
            end
        endcase
    end

    // Update current state and output
    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000; // synchronous reset
        end else begin
            y <= next_y;
        end
    end

    assign z = z_wire; // assign output wire to output port

endmodule
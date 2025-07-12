module TopModule(
    input        clk,
    input        areset,
    input        x,
    output       z
);

reg [1:0] state, next_state;
wire       z_wire;

// Define states
parameter A = 2'b10;
parameter B = 2'b01;

// Output logic
assign z = z_wire;

// Combinational logic
always @(*) begin
    case(state)
        A: begin
            if(!x) begin
                next_state = A;
                z_wire = 1'b0;
            end else begin
                next_state = B;
                z_wire = 1'b1;
            end
        end
        B: begin
            if(!x) begin
                next_state = B;
                z_wire = 1'b1;
            end else begin
                next_state = B;
                z_wire = 1'b0;
            end
        end
        default: begin
            next_state = A;
            z_wire = 1'b0;
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Assign output
assign z = z_wire;

endmodule
module TopModule(
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

// Load controller module
module load_controller(
    input  load,
    input  [3:0] data,
    output [3:0] load_data
);
    assign load_data = load ? data : 4'b0;
endmodule

// Shift register array module
module shift_register_array(
    input  clk,
    input  areset,
    input  ena,
    input  [3:0] load_data,
    output [3:0] q
);
    reg [3:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 4'b0;
        end else if (ena) begin
            q_reg <= {1'b0, q_reg[3:1]};
        end else if (load_data != 4'b0) begin
            q_reg <= load_data;
        end else begin
            q_reg <= q_reg;
        end
    end

    assign q = q_reg;
endmodule

// Instantiate load controller and shift register array
wire [3:0] load_data;
load_controller u_load_controller(
    .load(load),
    .data(data),
    .load_data(load_data)
);

shift_register_array u_shift_register_array(
    .clk(clk),
    .areset(areset),
    .ena(ena),
    .load_data(load_data),
    .q(q)
);

endmodule
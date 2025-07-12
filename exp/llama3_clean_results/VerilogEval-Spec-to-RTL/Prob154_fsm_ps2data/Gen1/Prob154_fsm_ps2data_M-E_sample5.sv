module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Internal signals
logic [23:0] shift_register;
logic [1:0] byte_counter;
logic found_start;

// Combinational logic
always_comb begin
    done = 1'b0;
    out_bytes = 24'd0;

    if (byte_counter == 2'd3) begin
        done = 1'b1;
        out_bytes = shift_register;
    end
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        shift_register <= 24'd0;
        byte_counter <= 2'd0;
        found_start <= 1'b0;
    end else begin
        if (found_start) begin
            shift_register <= {in, shift_register[23:8]};
            byte_counter <= byte_counter + 1'b1;
        end else if (in[3] == 1'b1) begin
            shift_register <= {in, 16'd0};
            byte_counter <= 1'b1;
            found_start <= 1'b1;
        end
    end
end

endmodule
// StateController module
module StateController(
    input clk,
    input reset,
    input [7:0] in,
    output [1:0] state
);

reg [1:0] state_reg;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 2'b00;
    end else begin
        case (state_reg)
            2'b00: begin
                if (in[3] == 1'b1) begin
                    state_reg <= 2'b01;
                end else begin
                    state_reg <= 2'b00;
                end
            end
            2'b01: begin
                state_reg <= 2'b10;
            end
            2'b10: begin
                state_reg <= 2'b00;
            end
        endcase
    end
    state <= state_reg;
end

endmodule

// DataBuffer module
module DataBuffer(
    input clk,
    input [7:0] in,
    input [1:0] state,
    output [23:0] out_bytes
);

reg [23:0] out_bytes_reg;

always @(posedge clk) begin
    case (state)
        2'b01: begin
            out_bytes_reg[23:16] <= in;
        end
        2'b10: begin
            out_bytes_reg[15:8] <= in;
        end
        2'b00: begin
            out_bytes_reg[7:0] <= in;
        end
    endcase
    out_bytes <= out_bytes_reg;
end

endmodule

// OutputGenerator module
module OutputGenerator(
    input [1:0] state,
    input [23:0] out_bytes,
    output done,
    output [23:0] out_bytes_final
);

assign done = (state == 2'b00);
assign out_bytes_final = out_bytes;

endmodule

// TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

wire [1:0] state;
wire [23:0] out_bytes_wire;

StateController state_controller(clk, reset, in, state);
DataBuffer data_buffer(clk, in, state, out_bytes_wire);
OutputGenerator output_generator(state, out_bytes_wire, done, out_bytes);

endmodule
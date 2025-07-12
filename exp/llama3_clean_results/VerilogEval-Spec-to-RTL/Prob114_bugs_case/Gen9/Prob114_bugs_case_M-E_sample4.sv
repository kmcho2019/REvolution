module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    // Define a struct to hold scancode and output value
    typedef struct {
        logic [7:0] scancode;
        logic [3:0] output;
    } scancode_map;

    // Array of scancode maps
    scancode_map scancodes[] = '{
        '{8'h45, 4'd0},
        '{8'h16, 4'd1},
        '{8'h1e, 4'd2},
        '{8'h26, 4'd3},
        '{8'h25, 4'd4},
        '{8'h2e, 4'd5},
        '{8'h36, 4'd6},
        '{8'h3d, 4'd7},
        '{8'h3e, 4'd8},
        '{8'h46, 4'd9}
    };

    // Combinational logic
    always @(*) begin
        out = 4'd0;
        valid = 1'b0;
        for (genvar i = 0; i < scancodes.size(); i++) begin
            if (code == scancodes[i].scancode) begin
                out = scancodes[i].output;
                valid = 1'b1;
            end
        end
    end

endmodule
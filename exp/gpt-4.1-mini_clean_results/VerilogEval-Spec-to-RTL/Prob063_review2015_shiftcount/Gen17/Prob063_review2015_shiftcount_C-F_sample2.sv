module TopModule(
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

    reg init_done;

    wire [3:0] shifted_val = {q[2:0], data};
    wire [3:0] decremented_val = q + 4'b1111;  // q - 1 mod 16 using addition
    wire [3:0] next_val;

    // Select next value based on enables; priority shift_ena over count_ena (arbitrary per problem)
    assign next_val = shift_ena ? shifted_val :
                      count_ena ? decremented_val :
                      q;

    // Register update gated to minimize switching: only update on init or when enables active
    always @(posedge clk) begin
        if (!init_done) begin
            q <= 4'b0000;
            init_done <= 1'b1;
        end
        else if (shift_ena || count_ena) begin
            q <= next_val;
        end
        else begin
            q <= q;  // hold value, explicitly for clarity
        end
    end

endmodule
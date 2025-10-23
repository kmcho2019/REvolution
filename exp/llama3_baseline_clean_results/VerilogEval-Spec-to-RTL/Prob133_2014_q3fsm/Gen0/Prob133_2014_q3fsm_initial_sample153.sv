module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// Enum for states
enum {A, B} state, next_state;

// Counter for clock cycles since entering state B
reg [1:0] counter;

// Counter for the number of times w = 1 in the current window
reg [1:0] w_count;

// Flag to set z = 1 in the next cycle if exactly two w = 1 were counted
reg set_z;

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        counter <= 0;
        w_count <= 0;
        set_z <= 0;
    end else begin
        case (state)
            A: begin
                if (s) begin
                    state <= B;
                    counter <= 1;
                    w_count <= w ? 1 : 0;
                end
            end
            B: begin
                counter <= counter + 1;
                if (w) begin
                    w_count <= w_count + 1;
                end
                if (counter == 3) begin
                    set_z <= (w_count == 2) ? 1 : 0;
                    w_count <= 0;
                    counter <= 1;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        z <= 0;
    end else begin
        if (set_z) begin
            z <= 1;
            set_z <= 0;
        end else begin
            z <= 0;
        end
    end
end

endmodule
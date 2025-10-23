module TopModule (
    input       clk,
    input       reset,
    input       in,
    output      done
);

    // Define states
    enum logic [1:0] {
        Idle,
        Start,
        Data,
        Stop
    } state, next_state;

    // Define internal signals
    logic [7:0] data;
    logic [2:0] count;

    // Combinational logic
    always_comb begin
        next_state = state;
        done = 1'b0;

        case (state)
            Idle: begin
                if (~in) begin
                    next_state = Start;
                end
            end

            Start: begin
                next_state = Data;
            end

            Data: begin
                if (count == 8) begin
                    next_state = Stop;
                end
            end

            Stop: begin
                if (in) begin
                    next_state = Idle;
                    done = 1'b1;
                end
            end

        endcase
    end

    // Sequential logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= Idle;
            data <= 8'b0;
            count <= 3'b0;
        end else begin
            case (state)
                Start: begin
                    data[0] <= in;
                end

                Data: begin
                    data[count] <= in;
                    count <= count + 1;
                end

                Stop: begin
                    if (in) begin
                        state <= Idle;
                        count <= 3'b0;
                    end
                end

                Idle: begin
                    count <= 3'b0;
                end

            endcase

            state <= next_state;
        end
    end

endmodule